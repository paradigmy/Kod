(defn fac [n]
   (if (= n 0)
      1
      (* n (fac (- n 1)))))

(println (fac 10))

(defn fib [n]
   (if (= n 0)
      0
      (if (= n 1)
         1
         (+ (fib (- n 1)) (fib (- n 2))))))
(println (fib 10))

(defn ack [m n]
   (if (= m 0)
      (+ n 1)
      (if (= n 0)
         (ack (- m 1) 1)
         (ack (- m 1) (ack m (- n 1))))))

(println (ack 3 3))

(defn prime [n k]
   (if (> (* k k) n) 
       #t
       (if (= (mod n k) 0) 
           #f
           (prime n (+ k 1)))))

(defn isPrime?[n]
     (and (> n 1) (prime n 2)))

(println (isPrime? 13))
