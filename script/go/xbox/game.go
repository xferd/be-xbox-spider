package xbox

import (
	"log"
	"database/sql"
	_ "github.com/go-sql-driver/mysql"
)

var (
	db *sql.DB
	err error
	stmt_add_game *sql.Stmt
)

func init() {
	db, err = sql.Open("mysql", "root:root@tcp(ub:3306)/xbox?charset=utf8")
	if nil != err {
		panic(err)
	}
	stmt_add_game, err = db.Prepare("INSERT INTO games(`ProductId`, `ProductTitle`, `ShortTitle`, `ShortDescription`) VALUES(?, ?, ?, ?) ON DUPLICATE KEY UPDATE ProductTitle=?, ShortTitle=?, ShortDescription=?")
	if nil != err {
		panic(err)
	}
}

func InsertUpdateGame(p *Product) error {
	log.Printf("product: %+v", p)
	lp := p.LocalizedProperties[0]
	if _, err := stmt_add_game.Exec(p.ProductId, lp.ProductTitle, lp.ShortTitle, lp.ShortDescription,
			lp.ProductTitle, lp.ShortTitle, lp.ShortDescription); nil != err {
		log.Fatalf("err %+v", err)
		return err
	}
	// defer stmt_add_game.Close()
	return nil
}
