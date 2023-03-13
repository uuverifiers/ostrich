(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\(\d{3}\) ?\d{3}( |-)?\d{4}|^\d{3}( |-)?\d{3}( |-)?\d{4}
(assert (not (str.in_re X (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; ^[A-G](b|#)?((m(aj)?|M|aug|dim|sus)([2-7]|9|13)?)?(\/[A-G](b|#)?)?$
(assert (not (str.in_re X (re.++ (re.range "A" "G") (re.opt (re.union (str.to_re "b") (str.to_re "#"))) (re.opt (re.++ (re.union (re.++ (str.to_re "m") (re.opt (str.to_re "aj"))) (str.to_re "M") (str.to_re "aug") (str.to_re "dim") (str.to_re "sus")) (re.opt (re.union (re.range "2" "7") (str.to_re "9") (str.to_re "13"))))) (re.opt (re.++ (str.to_re "/") (re.range "A" "G") (re.opt (re.union (str.to_re "b") (str.to_re "#"))))) (str.to_re "\u{0a}")))))
; Ready[^\n\r]*User-Agent\x3A\s+Client\dFrom\x3AWebtool\x2Eworld2\x2EcnUser-Agent\x3AUser-Agent\u{3a}
(assert (str.in_re X (re.++ (str.to_re "Ready") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Client") (re.range "0" "9") (str.to_re "From:Webtool.world2.cn\u{13}User-Agent:User-Agent:\u{0a}"))))
(check-sat)
