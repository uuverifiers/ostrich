(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Ready[^\n\r]*User-Agent\x3A\s+Client\dFrom\x3AWebtool\x2Eworld2\x2EcnUser-Agent\x3AUser-Agent\u{3a}
(assert (str.in_re X (re.++ (str.to_re "Ready") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Client") (re.range "0" "9") (str.to_re "From:Webtool.world2.cn\u{13}User-Agent:User-Agent:\u{0a}"))))
; /\(\?[gimxs]{1,5}\)/
(assert (not (str.in_re X (re.++ (str.to_re "/(?") ((_ re.loop 1 5) (re.union (str.to_re "g") (str.to_re "i") (str.to_re "m") (str.to_re "x") (str.to_re "s"))) (str.to_re ")/\u{0a}")))))
; ^\d*\d?((5)|(0))\.?((0)|(00))?$
(assert (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.union (str.to_re "5") (str.to_re "0")) (re.opt (str.to_re ".")) (re.opt (re.union (str.to_re "0") (str.to_re "00"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
