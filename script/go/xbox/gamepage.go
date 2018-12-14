package xbox

import (
	"log"
	"fmt"
	"os"
	"io/ioutil"
)

const (
	GamePagePath = "/data/xbox/page/"
)

type GamePageInfo struct {
	Pid ProductID
	L Lang
}

var (
	gamePageChan chan *GamePageInfo = make(chan *GamePageInfo, 128)
)

func getGamePageURL(pid ProductID, l Lang) string {
	const URLFormat = "https://www.microsoft.com/%s/p/GAME/%s?activetab=pivot%%3Aoverviewtab"
	return fmt.Sprintf(URLFormat, l, pid)
}

func CrawlGamePage(pid ProductID, l Lang) {
	info := &GamePageInfo{
		Pid: pid,
		L: l,
	}
	gamePageChan <- info
	go func() {
		wgCrawl.Add(1)
		defer func() {
			<- gamePageChan
			wgCrawl.Done()
		}()
		crawlGamePage(info)
	}()
}

func crawlGamePage(info *GamePageInfo) error {
	pid := info.Pid
	l := info.L
	gameURL := getGamePageURL(pid, l)
	html, err := GetURL(gameURL)
	if nil != err {
		return err
	}
	log.Println(html, gameURL)
	dir := fmt.Sprintf("%s%s", GamePagePath, l)
	if err := os.MkdirAll(dir, os.ModePerm); nil != err {
		panic(err)
	}
	filename := fmt.Sprintf("%s/%s", dir, pid)
	return ioutil.WriteFile(filename, []byte(html), os.ModePerm)
}
