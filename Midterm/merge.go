vid. cvicenie 3

func cmergesort(low, high int, ch chan bool) {
	if low < high {
		middle := low + (high-low)/2
		if high-low < granularity { // granularita, utried sekvencne
			mergesort(low, middle)
			mergesort(middle+1, high)
			merge(low, middle, high)
		} else {
			ch1 := make(chan bool)
			goroutines++
			go cmergesort(low, middle, ch1)
			ch2 := make(chan bool)
			goroutines++
			go cmergesort(middle+1, high, ch2)
			<-ch1
			<-ch2
			merge(low, middle, high)
		}
	}
	ch <- true
} 

alebo mutex

func cmergesort(low, high int, wg *sync.WaitGroup) {
	if low < high {
		middle := low + (high-low)/2
		if high-low < granularity { // granularita
			mergesort(low, middle)
			mergesort(middle+1, high)
			merge(low, middle, high)
		} else {
			wg := new(sync.WaitGroup)
			wg.Add(2)
			goroutines++
			go cmergesort(low, middle, wg)
			goroutines++
			go cmergesort(middle+1, high, wg)
			wg.Wait() // cakaj, kym obaja dokoncia
			merge(low, middle, high)
		}
	}
	wg.Done()
}
