public class Concurrency {

    static int globalVar = 0;
    static Thread smallThread(String label, int delta) {
        return
//                new Thread(new Runnable() {
//                    @Override
//                    public void run() {
//                        System.out.println(label + (globalVar += delta));
//                    }
//                });
        new Thread(
                //() -> {globalVar += delta;}
                () -> System.out.println(label + (globalVar += delta))
        );
    }
    public static void main(String[] args) throws InterruptedException {
        do {
            globalVar = 0;
            Thread t1 = smallThread("prvy", 10);
            t1.start();
            Thread t2 = smallThread("druhy", 20);
            t2.start();
            t1.join();
            t2.join();
            System.out.println(globalVar);
        } while (globalVar == 30);
    }
}
