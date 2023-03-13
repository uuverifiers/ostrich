(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Everyware.*Email.*Host\x3Astepwww\x2Ekornputers\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Everyware") (re.* re.allchar) (str.to_re "Email") (re.* re.allchar) (str.to_re "Host:stepwww.kornputers.com\u{0a}"))))
; Ready\s+Client\dFrom\x3AWebtool\x2Eworld2\x2EcnUser-Agent\x3AUser-Agent\u{3a}URLencoderthis\x7CConnected
(assert (not (str.in_re X (re.++ (str.to_re "Ready") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Client") (re.range "0" "9") (str.to_re "From:Webtool.world2.cn\u{13}User-Agent:User-Agent:URLencoderthis|Connected\u{0a}")))))
; ^([1-9]+\d{0,2},(\d{3},)*\d{3}(\.\d{1,2})?|[1-9]+\d*(\.\d{1,2})?)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.+ (re.range "1" "9")) ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))))) (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
; 0{3,}|1{3,}|2{3,}|3{3,}|4{3,}|5{3,}|6{3,}|7{3,}|8{3,}|9{3,}
(assert (str.in_re X (re.union (re.++ ((_ re.loop 3 3) (str.to_re "0")) (re.* (str.to_re "0"))) (re.++ ((_ re.loop 3 3) (str.to_re "1")) (re.* (str.to_re "1"))) (re.++ ((_ re.loop 3 3) (str.to_re "2")) (re.* (str.to_re "2"))) (re.++ ((_ re.loop 3 3) (str.to_re "3")) (re.* (str.to_re "3"))) (re.++ ((_ re.loop 3 3) (str.to_re "4")) (re.* (str.to_re "4"))) (re.++ ((_ re.loop 3 3) (str.to_re "5")) (re.* (str.to_re "5"))) (re.++ ((_ re.loop 3 3) (str.to_re "6")) (re.* (str.to_re "6"))) (re.++ ((_ re.loop 3 3) (str.to_re "7")) (re.* (str.to_re "7"))) (re.++ ((_ re.loop 3 3) (str.to_re "8")) (re.* (str.to_re "8"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 3 3) (str.to_re "9")) (re.* (str.to_re "9"))))))
; ^\d$
(assert (not (str.in_re X (re.++ (re.range "0" "9") (str.to_re "\u{0a}")))))
(check-sat)
