(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^#(\d{6})|^#([A-F]{6})|^#([A-F]|[0-9]){6}
(assert (not (str.in_re X (re.++ (str.to_re "#") (re.union ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 6 6) (re.range "A" "F")) (re.++ ((_ re.loop 6 6) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "\u{0a}")))))))
; Ready\s+Client\dFrom\x3AWebtool\x2Eworld2\x2EcnUser-Agent\x3AUser-Agent\u{3a}URLencoderthis\x7CConnected
(assert (not (str.in_re X (re.++ (str.to_re "Ready") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Client") (re.range "0" "9") (str.to_re "From:Webtool.world2.cn\u{13}User-Agent:User-Agent:URLencoderthis|Connected\u{0a}")))))
; (^[0-9]{2,3}\.[0-9]{3}\.[0-9]{3}\/[0-9]{4}-[0-9]{2}$)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))))))
; (([+]?34) ?)?(6(([0-9]{8})|([0-9]{2} [0-9]{6})|([0-9]{2} [0-9]{3} [0-9]{3}))|9(([0-9]{8})|([0-9]{2} [0-9]{6})|([1-9] [0-9]{7})|([0-9]{2} [0-9]{3} [0-9]{3})|([0-9]{2} [0-9]{2} [0-9]{2} [0-9]{2})))
(assert (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re " ")) (re.opt (str.to_re "+")) (str.to_re "34"))) (re.union (re.++ (str.to_re "6") (re.union ((_ re.loop 8 8) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 6 6) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (str.to_re "9") (re.union ((_ re.loop 8 8) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 6 6) (re.range "0" "9"))) (re.++ (re.range "1" "9") (str.to_re " ") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9")))))) (str.to_re "\u{0a}"))))
; ((IT|LV)-?)?[0-9]{11}
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "IT") (str.to_re "LV")) (re.opt (str.to_re "-")))) ((_ re.loop 11 11) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
