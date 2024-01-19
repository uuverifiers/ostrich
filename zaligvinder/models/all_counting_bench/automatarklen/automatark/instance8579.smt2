(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^(([01]?\d?\d|2[0-4]\d|25[0-5])\.){3}([01]?\d?\d|2[0-4]\d|25[0-5])\/(\d{1}|[0-2]{1}\d{1}|3[0-2])$/
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 3 3) (re.++ (re.union (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.opt (re.range "0" "9")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re "."))) (re.union (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.opt (re.range "0" "9")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re "/") (re.union ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.range "0" "2")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "3") (re.range "0" "2"))) (str.to_re "/\u{0a}")))))
; ^([a-zA-Z ';-]+)$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re " ") (str.to_re "'") (str.to_re ";") (str.to_re "-"))) (str.to_re "\u{0a}"))))
; ^#?([a-f]|[A-F]|[0-9]){3}(([a-f]|[A-F]|[0-9]){3})?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "#")) ((_ re.loop 3 3) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (re.opt ((_ re.loop 3 3) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; href[ ]*=[ ]*('|\")([^\"'])*('|\")
(assert (not (str.in_re X (re.++ (str.to_re "href") (re.* (str.to_re " ")) (str.to_re "=") (re.* (str.to_re " ")) (re.union (str.to_re "'") (str.to_re "\u{22}")) (re.* (re.union (str.to_re "\u{22}") (str.to_re "'"))) (re.union (str.to_re "'") (str.to_re "\u{22}")) (str.to_re "\u{0a}")))))
; AID\x2FHost\u{3a}Hourskl\x2Esearch\x2Eneed2find\x2EcomHost\u{3a}Host\x3A
(assert (str.in_re X (str.to_re "AID/Host:Hourskl.search.need2find.comHost:Host:\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
