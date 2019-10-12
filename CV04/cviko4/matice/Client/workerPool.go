package main


type WorkerPool struct {
	workers []*Worker
	tasks   []*Task
}

func NewWorkerPool(Brigada []string) *WorkerPool {
	workers := make([]*Worker, len(Brigada))
	for i, port := range Brigada {
		workers[i] = NewWorker("localhost", port) // :8000, 
	}
	tasks := make([]*Task, 0)
	return &WorkerPool{workers, tasks}
}

func (wp *WorkerPool) addTask(t *Task) {
	wp.tasks = append(wp.tasks, t) // pridaj na koniec fronty
}

func (wp *WorkerPool) mainLoop(chainRes chan Result) {
	for len(wp.tasks) > 0 {
		for _, w := range wp.workers {
			if w.busy == false && w.conn != nil {
				w.busy = true
				t := wp.tasks[0]
				wp.tasks = wp.tasks[1:]
				go w.doit(t, chainRes)
				break
			}
		}
		//time.Sleep(0 * time.Millisecond)
	}
}



