package xbox

import (
    "net/http"
    "io/ioutil"
)

func GetURL(url string) (string, error) {
    resp, err := http.Get(url)
    if nil != err {
    return "", nil
    }
    defer resp.Body.Close()
    bytes, err := ioutil.ReadAll(resp.Body)
    if nil != err {
    return "", err
    }
    return string(bytes), nil
}
