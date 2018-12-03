package xbox

import (
	"encoding/json"
)

type LocalizedProperties struct {
	ProductTitle string
	ShortTitle string
	ProductDescription string
	ShortDescription string
	Markets []string
}

type Product struct {
	ProductId string
	LocalizedProperties LocalizedProperties
}

var (

)

func (p *Product)Markets() {
	json.Unmarshal
}
