package main

import (
	"fmt"
	"net/http"
	"io/ioutil"
	"time"
)

func main() {

	url := "https://ipsc.ksp.sk/2018/practice/problems/r2"

	req, _ := http.NewRequest("POST", url, nil)

	req.Header.Add("cache-control", "no-cache")
	req.Header.Add("postman-token", "e0d135f4-f2ed-04f2-2f08-0bd9404655b0")

	expire := time.Now().Add(10 * time.Minute)
	cookie := http.Cookie{Name: "_ga", Value: "GA1.2.1532501745.1537515380", Path: "/", Expires: expire, MaxAge: 90000}
	req.AddCookie(&cookie);

	cookie1 := http.Cookie{Name: "ipsc2018ann", Value: "3", Path: "/", Expires: expire, MaxAge: 90000}
	req.AddCookie(&cookie1);

	cookie2 := http.Cookie{Name: "ipscsessid", Value: "3ab13a676a7563ee653363a58f1fe361ed18d1e1", Path: "/", Expires: expire, MaxAge: 90000}
	req.AddCookie(&cookie2);

	cookie3 := http.Cookie{Name: "ipsctrainann", Value: "7", Path: "/", Expires: expire, MaxAge: 90000}
	req.AddCookie(&cookie3);

	res, _ := http.DefaultClient.Do(req)

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)

	fmt.Println(res)
	fmt.Println(string(body))

}