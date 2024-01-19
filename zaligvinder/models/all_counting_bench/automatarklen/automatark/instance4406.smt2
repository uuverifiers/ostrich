(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /rec\.php$/Usmi
(assert (str.in_re X (str.to_re "/rec.php/Usmi\u{0a}")))
; ookflolfctm\u{2f}nmot\.fmu
(assert (str.in_re X (str.to_re "ookflolfctm/nmot.fmu\u{0a}")))
; \x5BStaticHost\x3AFROM\x3Acs\x2Eshopperreports\x2Ecommedia\x2Etop-banners\x2Ecom\x2Fbar_pl\x2Fb\.fcgi
(assert (not (str.in_re X (str.to_re "[StaticHost:FROM:cs.shopperreports.commedia.top-banners.com/bar_pl/b.fcgi\u{0a}"))))
; /\.php\?id=(\d{5}-\d{3}-\d{7}-\d{5}|0[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}1)&ver=\d{7}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/.php?id=") (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 5 5) (re.range "0" "9"))) (re.++ (str.to_re "0") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "-") ((_ re.loop 3 3) (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "-"))) ((_ re.loop 12 12) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "1"))) (str.to_re "&ver=") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
