package main

import (
	"os"
	"log"
	"regexp"

	"github.com/xferd/be-xbox-spider/script/go/xbox"
)

const (
)

var (
	expID *regexp.Regexp
	_ = log.LUTC
)

func init() {
	exp, err := regexp.Compile("\"([A-Z0-9]{12})\"")
	if nil != err {
		panic(err)
	}
	expID = exp
}

func main() {
	resp, err := xbox.GetURL(xbox.GameIDUrl)
	if nil != err {
		panic(err)
	}

	if founds := expID.FindAllStringSubmatch(resp, -1); len(founds) > 0 {
		fp, err := os.Create(xbox.ProductIDListFile)
		if nil != err {
			panic(err)
		}
		defer fp.Close()
		for _, match := range founds {
			id := match[1]
			fp.Write([]byte(id + "\n"))
		}
	}
}
