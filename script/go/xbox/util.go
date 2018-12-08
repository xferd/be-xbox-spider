package xbox

import (
    "net/http"
    "io/ioutil"
    "crypto/md5" 
    "encoding/hex" 
    "fmt" 
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

func MD5(cipher []byte) string {
    h := md5.New() 
    h.Write(cipher) // 需要加密的字符串为 123456 
    cipherStr := h.Sum(nil) 
    return fmt.Sprintf("%s\n", hex.EncodeToString(cipherStr)) // 输出加密结果 
}
