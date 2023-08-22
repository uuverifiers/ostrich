(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{1,3}'(\d{3}')*\d{3}(\.\d{1,3})?|\d{1,3}(\.\d{3})?)$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "'") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "'"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
; Toolbarverpop\x2Epopuptoast\x2Ecomtvshowticketscount\x2Eyok\x2Ecom
(assert (not (str.in_re X (str.to_re "Toolbarverpop.popuptoast.comtvshowticketscount.yok.com\u{0a}"))))
; ^[\w]{3}(p|P|c|C|h|H|f|F|a|A|t|T|b|B|l|L|j|J|g|G)[\w][\d]{4}[\w]$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re "p") (str.to_re "P") (str.to_re "c") (str.to_re "C") (str.to_re "h") (str.to_re "H") (str.to_re "f") (str.to_re "F") (str.to_re "a") (str.to_re "A") (str.to_re "t") (str.to_re "T") (str.to_re "b") (str.to_re "B") (str.to_re "l") (str.to_re "L") (str.to_re "j") (str.to_re "J") (str.to_re "g") (str.to_re "G")) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) ((_ re.loop 4 4) (re.range "0" "9")) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (str.to_re "\u{0a}")))))
; (\(")([0-9]*)(\")
(assert (str.in_re X (re.++ (str.to_re "(\u{22}") (re.* (re.range "0" "9")) (str.to_re "\u{22}\u{0a}"))))
; Informationurl=Host\x3Aaction\x2Eforhttp\x3A\x2F\x2Fwww\.searchinweb\.com\x2Fsearch\.php\?said=bar
(assert (str.in_re X (str.to_re "Informationurl=Host:action.forhttp://www.searchinweb.com/search.php?said=bar\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
