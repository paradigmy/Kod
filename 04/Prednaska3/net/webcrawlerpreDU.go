package main

import (
	"fmt"
	"time"
)

type Fetcher interface {
	// Fetch returns the body of URL and
	// a slice of URLs found on that page.
	Fetch(url string) (body string, urls []string, err error)
}

var fetcher Fetcher

// Crawl uses fetcher to recursively crawl
// pages starting with url, to a maximum of depth.
func Crawl71(url string, depth int) {
	// TODO: Fetch URLs in parallel.
	// TODO: Don't fetch the same URL twice.
	// This implementation doesn't do either:
	if depth < 0 {
		return
	}
	visited[url] = true
	body, urls, err := fetcher.Fetch(url)
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Printf("[%d:%s] %q\n", depth, url, body)
	//fmt.Printf("found: %s %q\n", url, body)
	if depth > 0 {
		for _, u := range urls {
			Crawl71(u, depth-1)
		}
	}
	return
}

var (
	globalQueueOfUrls = make(chan Urls)
	totalRuns         = 0
	visited           = make(map[string]bool)
)

type Urls struct {
	depth   int
	suburls []string
}

func crawlPageR(url string, depth int) *Urls {
	body, urls, err := fetcher.Fetch(url)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("[%d:%s] %q\n", depth, url, body)
	}
	return &Urls{depth + 1, urls}
}

func CrawlR(url string, depth int, maxDepth int) {
	//fmt.Print(len(visited))
	if depth <= maxDepth {
		visited[url] = true
		suburls := crawlPageR(url, depth)
		if depth < maxDepth {
			for _, url := range suburls.suburls {
				if _, seen := visited[url]; seen {
					continue
				}
				CrawlR(url, depth+1, maxDepth)
			}
		}
	}
}

//--------------------
func crawlPage(url string, depth int) {
	body, urls, err := fetcher.Fetch(url)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("[%d:%s] %q\n", depth, url, body)
	}
	globalQueueOfUrls <- Urls{depth + 1, urls}
}

func Crawl(url string, depth int) {
	totalRuns++
	visited[url] = true
	go crawlPage(url, 0)
	for totalRuns > 0 {
		totalRuns--
		next := <-globalQueueOfUrls
		if next.depth > depth {
			continue
		}
		for _, url := range next.suburls {
			if _, seen := visited[url]; seen {
				continue
			}
			visited[url] = true
			if next.depth < depth {
				totalRuns++
				go crawlPage(url, next.depth)
			}
		}
	}
}

func main() {
	//fetcher = fakefetcher // tento ide do vlastnej pidi datovej struktury
	fetcher = realfetcher // tento ide na web

	url := "http://dai.fmph.uniba.sk/courses/JAVA"
	//url := "http://dai.fmph.uniba.sk/courses/PARA"
	//url := "http://golang.org/"
	//url := "http://dai.fmph.uniba.sk/"
	depth := 2
	//------------------------------------------------
	start := time.Now()

	// navštivi viackrat stranky

	//Crawl71(url, depth)

	// http://dai.fmph.uniba.sk/courses/JAVA
	// size: 1097
	// 8m44.3811769s

	// http://dai.fmph.uniba.sk/courses/PARA
	// size: 236
	// 1m7.1152031s

	// http://golang.org
	// size: 317
	// 2m10.9955306s

	// http://dai.fmph.uniba.sk/
	// ... ?

	//---------------------------------------------------------------------
	// rekurzivy jemne zoprimalizovany crawler, pamata si navstivene stranky

	CrawlR(url, 0, depth)

	// http://dai.fmph.uniba.sk/courses/JAVA
	// size: 1097
	// 6m47.2779048s

	// http://dai.fmph.uniba.sk/courses/PARA
	// size: 79
	// 1.6984467s

	// http://golang.org
	// size: 163
	// 1m9.2333664s

	//---------------------------------------------------------------------
	// konkurentny crawler

	 //Crawl(url, depth)

	// http://dai.fmph.uniba.sk/courses/JAVA
	// size: 1097
	// 1.5778854s

	// http://dai.fmph.uniba.sk/courses/PARA
	// size: 236
	// 808.6346ms

	// http://golang.org
	// size: 317
	// 1.2192617s

	// http://dai.fmph.uniba.sk/
	// size: 2024
	// 4.7803725s
	//---------------------------------------------------------------------
	//-------------------------
	fmt.Printf("visited: %v\n", visited)
	fmt.Printf("size: %d\n", len(visited))
	fmt.Println(time.Since(start))
}

// fakeFetcher is Fetcher that returns canned results.
type fakeFetcher map[string]*fakeResult

type fakeResult struct {
	body string
	urls []string
}

func (f *fakeFetcher) Fetch(url string) (string, []string, error) {
	if res, ok := (*f)[url]; ok {
		return res.body, res.urls, nil
	}
	return "", nil, fmt.Errorf("not found: %s", url)
}

// fetcher is a populated fakeFetcher.
var fakefetcher = &fakeFetcher{
	"http://golang.org/": &fakeResult{
		"The Go Programming Language",
		[]string{
			"http://golang.org/pkg/",
			"http://golang.org/cmd/",
		},
	},
	"http://golang.org/pkg/": &fakeResult{
		"Packages",
		[]string{
			"http://golang.org/",
			"http://golang.org/cmd/",
			"http://golang.org/pkg/fmt/",
			"http://golang.org/pkg/os/",
		},
	},
	"http://golang.org/pkg/fmt/": &fakeResult{
		"Package fmt",
		[]string{
			"http://golang.org/",
			"http://golang.org/pkg/",
		},
	},
	"http://golang.org/pkg/os/": &fakeResult{
		"Package os",
		[]string{
			"http://golang.org/",
			"http://golang.org/pkg/",
		},
	},
}

type RealFetcher struct{}

var realfetcher *RealFetcher = new(RealFetcher)

func (f *RealFetcher) Fetch(url string) (body string, urls []string, err error) {
	return url, urls, nil
}
