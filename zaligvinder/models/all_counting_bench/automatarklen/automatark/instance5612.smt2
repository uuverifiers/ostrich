(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(((((((00|\+)49[ \-/]?)|0)[1-9][0-9]{1,4})[ \-/]?)|((((00|\+)49\()|\(0)[1-9][0-9]{1,4}\)[ \-/]?))[0-9]{1,7}([ \-/]?[0-9]{1,5})?)$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "/"))) (re.union (re.++ (re.union (str.to_re "00") (str.to_re "+")) (str.to_re "49") (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "/")))) (str.to_re "0")) (re.range "1" "9") ((_ re.loop 1 4) (re.range "0" "9"))) (re.++ (re.union (re.++ (re.union (str.to_re "00") (str.to_re "+")) (str.to_re "49(")) (str.to_re "(0")) (re.range "1" "9") ((_ re.loop 1 4) (re.range "0" "9")) (str.to_re ")") (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "/"))))) ((_ re.loop 1 7) (re.range "0" "9")) (re.opt (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "/"))) ((_ re.loop 1 5) (re.range "0" "9"))))))))
; Host\x3AAddressDaemonUser-Agent\x3AUser-Agent\u{3a}
(assert (str.in_re X (str.to_re "Host:AddressDaemonUser-Agent:User-Agent:\u{0a}")))
; ^(smtp)\.([\w\-]+)\.[\w\-]{2,3}$
(assert (not (str.in_re X (re.++ (str.to_re "smtp.") (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 2 3) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}asx/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".asx/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
