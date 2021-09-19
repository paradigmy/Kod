// rekurzia
fun recursiveSum(n: Long) : Long {
    return if (n <= 1) {
        n
    } else {
        n + recursiveSum(n - 1)
    }
}
// chvostová rekurzia - alias iterácia - resp cyklus
tailrec fun Sum(n: Long, accum: Long = 0): Long {
    return if (n <= 0) {
        accum
    } else {
        Sum(n - 1, n + accum)
    }
}
fun main() {
    //val n = 10_000L; // už malý Gauss vedel, že to je [n*(n+1)]/2
    //val n = 1_000_000L;
    val n = 1_000_000_000L;
    //println(recursiveSum(n))  // neprežije už 100.000
    println(Sum(n))
}
