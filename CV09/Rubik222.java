public class Rubik222 {   // model RK 2x2x2
    private byte[][] top, down, left, right, front, back;  // steny kocky, T, D, L, R, F, B

    public Rubik222() {  // vytvori kocku s indexami 1.. 24
        byte c = 1;
        top =   new byte[][]{{c, c}, {c, c}};      c++;
        down =  new byte[][]{{c, c}, {c, c}};      c++;
        left =  new byte[][]{{c, c}, {c, c}};      c++;
        right = new byte[][]{{c, c}, {c, c}};      c++;
        front = new byte[][]{{c, c}, {c, c}};      c++;
        back =  new byte[][]{{c, c}, {c, c}};      c++;
    }
    // cielom je alokovat co najmenej pamate, aby to nepadlo na GC
    public Rubik222 copy(String move) {
        Rubik222 c = new Rubik222();
        c.top =     new byte[][]{{top[0][0], top[0][1]}, {top[1][0], top[1][1]}};
        c.down =    new byte[][]{{down[0][0], down[0][1]}, {down[1][0], down[1][1]}};
        c.left =    new byte[][]{{left[0][0], left[0][1]}, {left[1][0], left[1][1]}};
        c.right =   new byte[][]{{right[0][0], right[0][1]}, {right[1][0], right[1][1]}};
        c.front =   new byte[][]{{front[0][0], front[0][1]}, {front[1][0], front[1][1]}};
        c.back =    new byte[][]{{back[0][0], back[0][1]}, {back[1][0], back[1][1]}};
        return c;
    }
    // nakopiruje this do kocky c, a nic nealokuje
    public Rubik222 copy2(Rubik222 c) {
        for (int i = 0; i < 2; i++)
            for (int j = 0; j < 2; j++) {
                c.top[i][j] =   top[i][j];
                c.left[i][j] =  left[i][j];
                c.right[i][j] = right[i][j];
                c.front[i][j] = front[i][j];
                c.back[i][j] =  back[i][j];
                c.down[i][j] =  down[i][j];
            }
        return c;
    }
    // kopirovanie jednej steny kocky
    public void assign(byte[][] to, byte[][] from) {
        for (int i = 0; i < 2; i++)
            for (int j = 0; j < 2; j++)
                to[i][j] = from[i][j];
    }
    // rotacia jednej steny kocky, clockwise
    //   +--------+                      +-------+
    //   |s00 s01|                       |s10 s00|
    //   |s10 s11|      sa zrotuje do    |s11 s01|
    //   +-------+                       +-------+
    public void rotate(byte[][] side) {
        byte res00 = side[1][0], res01 = side[0][0], res10 = side[1][1], res11 = side[0][1];
        side[0][0] = res00;
        side[0][1] = res01;
        side[1][0] = res10;
        side[1][1] = res11;
    }
    // rotacia steny anti-clockwise, to uz som lenivy programovat, otocim 3xclockwise...
    public void rotatePrime(byte[][] side) {
        rotate(side); rotate(side); rotate(side);
    }
    // vymena stlpcov na stene
    //   +--------+                      +-------+
    //   |s00 s01|                       |s01 s00|
    //   |s10 s11|      sa vymeni na     |s11 s10|
    //   +-------+                       +-------+
    public void flipCols(byte[][] side) {
        byte res00 = side[0][1];
        byte res01 = side[0][0];
        byte res10 = side[1][1];
        byte res11 = side[1][0];
        side[0][0] = res00;
        side[0][1] = res01;
        side[1][0] = res10;
        side[1][1] = res11;
    }
    // vymena riadkov na stene
    //   +--------+                      +-------+
    //   |s00 s01|                       |s10 s11|
    //   |s10 s11|      sa vymeni na     |s00 s01|
    //   +-------+                       +-------+
    public void flipRows(byte[][] side) {
        byte res00 = side[1][0];
        byte res01 = side[1][1];
        byte res10 = side[0][0];
        byte res11 = side[0][1];
        side[0][0] = res00;
        side[0][1] = res01;
        side[1][0] = res10;
        side[1][1] = res11;
    }
    // rotacia kocky okolo osi x, clockwise
    public void x() {
        byte[][] restop = front;
        flipRows(back);        byte[][] resdown = back;
        rotatePrime(left);     byte[][] resleft = left;
        rotate(right);         byte[][] resright = right;
        flipRows(down);        byte[][] resfront = down;
        byte[][] resback = top;
        top = restop;
        down = resdown;
        left = resleft;
        right = resright;
        front = resfront;
        back = resback;
    }
    // rotacia kocky okolo osi x, anti-clockwise, opat 3x clockwise
    public void xPrime() {
        x(); x(); x();
    }
    // rotacia kocky okolo osi y, clockwise
    public void y() {
        rotate(top);        byte[][] restop = top;
        rotate(down);       byte[][] resdown = down;
        rotate(front);      byte[][] resleft = front;
        rotate(back);       byte[][] resright = back;
        rotate(right);      byte[][] resfront = right;
        rotate(left);       byte[][] resback = left;
        top = restop;
        down = resdown;
        left = resleft;
        right = resright;
        front = resfront;
        back = resback;
    }
    // rotacia kocky okolo osi y, anti-clockwise
    public void yPrime() {
        y(); y(); y();
    }
    // rotacia kocky okolo osi z, clockwise
    public void z() {
        byte[][] restop = right;
        flipCols(left);       byte[][] resdown = left;
        byte[][] resleft = top;
        flipCols(down);       byte[][] resright = down;
        rotatePrime(front);   byte[][] resfront = front;
        rotate(back);         byte[][] resback = back;
        top = restop;
        down = resdown;
        left = resleft;
        right = resright;
        front = resfront;
        back = resback;
    }
    // rotacia kocky okolo osi z, anti-clockwise
    public void zPrime() {
        z(); z(); z();
    }
    // predalokovane polia, aby sme nic nealokovali, co nemame pod kontrolou
    static byte[][] restop = new byte[2][2];
    static byte[][] resleft = new byte[2][2];
    static byte[][] resright = new byte[2][2];
    static byte[][] resfront = new byte[2][2];
    static byte[][] resback = new byte[2][2];

    //----------------------------------------- u
    // up clockwise
    public void u() {   // jednu elementarnu rotaciu steny musime nakodit, vsetky ostatne potom dostaneme trikom
        restop[0][0] = top[1][0];
        restop[0][1] = top[0][0];
        restop[1][0] = top[1][1];
        restop[1][1] = top[0][1];

        resleft[0][0] = left[0][0];
        resleft[0][1] = front[0][0];
        resleft[1][0] = left[1][0];
        resleft[1][1] = front[0][1];

        resright[0][0] = back[1][0];
        resright[0][1] = right[0][1];
        resright[1][0] = back[1][1];
        resright[1][1] = right[1][1];

        resfront[0][0] = right[1][0];
        resfront[0][1] = right[0][0];
        resfront[1][0] = front[1][0];
        resfront[1][1] = front[1][1];

        resback[0][0] = back[0][0];
        resback[0][1] = back[0][1];
        resback[1][0] = left[1][1];
        resback[1][1] = left[0][1];

        assign(top, restop);
        assign(left, resleft);
        assign(right, resright);
        assign(front, resfront);
        assign(back, resback);
    }

    public void uPrime() {
        u(); u(); u();
    }
    public void u2() {
        u(); u();
    }

    //----------------------------------------- l
    // tu uz treba predstavivost, alebo kocku...
    public void l() {
        zPrime(); u(); z();
    }

    public void lPrime() {
        l(); l(); l();
    }

    public void l2() {
        l(); l();
    }
    //----------------------------------------- f
    public void f() {
        x(); u(); xPrime();
    }

    public void fPrime() {
        f(); f(); f();
    }

    public void f2() {
        f(); f();
    }

    //----------------------------------------- r
    public void r() {
        z(); u(); zPrime();
    }

    public void rPrime() {
        r(); r(); r();
    }

    public void r2() {
        r(); r();
    }
    //----------------------------------------- b
    public void b() {
        xPrime(); u(); x();
    }

    public void bPrime() {
        b(); b(); b();
    }

    public void b2() {
        b(); b();
    }
    //----------------------------------------- d
    public void d() {
        x(); x(); u(); xPrime(); xPrime();
    }

    public void dPrime() {
        d(); d(); d();
    }

    public void d2() {
        d(); d();
    }
    //----------------------------------------- steny su rovnake
    public boolean same(byte[][] s, byte[][] ss) {
        return s[0][0] == ss[0][0] && s[0][1] == ss[0][1] && s[1][0] == ss[1][0] && s[1][1] == ss[1][1];
    }
    // --- kocky su rovnake, this == c
    public boolean same(Rubik222 cc) {
        return
                same(top, cc.top)     && same(back, cc.back) && same(left, cc.left) &&
                same(right, cc.right) && same(down, cc.down) && same(front, cc.front);
    }
    //------------------------------------------- toString potrebujete na print/debug vasho kodu
    // ale mozno vas napadne, ze podtebujete zistovat, v ktorych konfiguraciach ste uz boli, takze nejaky HashSet, ...
    // a ten musi implementovat Compare.
    // Akykolvek Compare, co som vyskusal bol pomalejsi, ako ked si z kociek urobim+pamatam toString a porovnavam Stringy
    // a aby stringy boli co najkratsie, samozrejme to chce nie uplne najprirodzenejsi toString, ale co najkompatnejsi
    // stena kocky RK 2x2x2 sa za zakodova do 16bit slova, takze cela kocka je 6 znakovy string 16-bit charakterov
    // samozrejme, s takymto toString sa to tazko ladi, a po chvilke mate pocit, ze rozumiete cinstine, to je pointa za
    // nasledujucim kodom
    public String toString() {
        return
                String.format(          // citatelny format
                        "\n      %2d,%2d \n      %2d,%2d \n" +
                                "%2d,%2d %2d,%2d %2d,%2d %2d,%2d\n" +
                                "%2d,%2d %2d,%2d %2d,%2d %2d,%2d\n" +
                                "      %2d,%2d \n      %2d,%2d \n",
                        back[0][0], back[0][1], back[1][0], back[1][1],
                        left[0][0], left[0][1], top[0][0], top[0][1], right[0][0], right[0][1], down[0][1], down[0][0],
                        left[1][0], left[1][1], top[1][0], top[1][1], right[1][0], right[1][1], down[1][1], down[1][0],
                        front[0][0], front[0][1], front[1][0], front[1][1]);


                  // trochu kondenzovanejsi zapis
//                //String.format("%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c",
//                //String.format("%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d",
//                 String.format("top=%d,%d,%d,%d, down=%d,%d,%d,%d, left=%d,%d,%d,%d, right=%d,%d,%d,%d, front=%d,%d,%d,%d, back=%d,%d,%d,%d",
//                top[0][0],top[0][1], top[1][0],top[1][1],
//                down[0][0],down[0][1], down[1][0],down[1][1],
//                left[0][0],left[0][1], left[1][0],left[1][1],
//                right[0][0],right[0][1], right[1][0],right[1][1],
//                front[0][0],front[0][1], front[1][0],front[1][1],
//                back[0][0],back[0][1], back[1][0],back[1][1]);

                  // este viac kondenzovane do 6 pismenkoveho stringu 16-bit charov
//                String.format("%c%c%c%c%c%c",
//                        (top  [0][0]<<12) | (top  [0][1]<<8) | (top  [1][0]<<4) | top  [1][1],
//                        (down [0][0]<<12) | (down [0][1]<<8) | (down [1][0]<<4) | down [1][1],
//                        (left [0][0]<<12) | (left [0][1]<<8) | (left [1][0]<<4) | left [1][1],
//                        (right[0][0]<<12) | (right[0][1]<<8) | (right[1][0]<<4) | right[1][1],
//                        (front[0][0]<<12) | (front[0][1]<<8) | (front[1][0]<<4) | front[1][1],
//                        (back [0][0]<<12) | (back [0][1]<<8) | (back [1][0]<<4) | back [1][1]);
    }
}
