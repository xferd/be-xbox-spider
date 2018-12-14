package xbox

import (
    "io"
    "bufio"
    "os"
    "fmt"
    "log"
    "io/ioutil"

    "github.com/xferd/golib/crypt"
)

type ProductIDChan chan ProductID
type Bag ProductIDList

var (
)

const (

)

func (ch ProductIDChan)walkAll() {
    go func() {
        fp, err := os.Open(ProductIDListFile)
        if nil != err {
            panic(err)
        }
        log.Printf("product id list file opened")
        defer fp.Close()

        rd := bufio.NewReader(fp)
        for {
            if line, _, err := rd.ReadLine(); nil == err || io.EOF != err {
                log.Printf("read line: %s", line)
                ch <- ProductID(line)
            } else {
                log.Printf("%+v", err)
                break
            }
        }
        close(ch)
    }()
}

func Crawl() {
    log.Printf("crawling")

    var idChan ProductIDChan = make(ProductIDChan)
    idChan.walkAll()
    var max, cnt = 100, 0
    bag := Bag{}
    for id := range idChan {
        cnt++
        bag.Add(id)
        if cnt >= max {
            bag.Flush()
            cnt = 0
        }
        fmt.Println(id)
    }
    bag.Flush()
    wgCrawl.Wait()
}

func (b *Bag)Add(id ProductID) {
    *b = append(*b, id)
}

func (b *Bag)Flush() {
    log.Println(b)
    for _, mkt := range []string{"US"} {
        _ = mkt
        for _, id := range ProductIDList(*b) {
            CrawlGamePage(id, "en-us")
        }
        // theURL := ProductIDList(*b).ProductURL(mkt, "zh-cn")
        // log.Println(theURL)
        // resp, err := GetURL(theURL)
        // if nil != err {
        //     panic(err)
        // }
        // // WriteProduct(theURL, resp)
        // products := ProductsFromJSON(resp)
        // products.InsertDB()
        // for _, p := range products.Products {
            // cc, lp, rp := p.GetPrice1()
            // if lp == rp {
            //     continue
            // }
            // log.Println(p.ProductId, cc, lp, rp, p.LocalizedProperties[0].ProductTitle)
        // }
    }
    *b = Bag{}
}

func WriteProduct(url, data string) {
    md5 := crypt.MD5([]byte(url))
    log.Println(md5)
    filepath := fmt.Sprintf("%s%s", ProductDir, md5)
    ioutil.WriteFile(filepath, []byte(data), os.ModePerm)
}
