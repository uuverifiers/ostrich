(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; hostie\s+freeIPaddrsBardata\.warezclient\.comHost\x3AUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "hostie") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "freeIPaddrsBardata.warezclient.comHost:User-Agent:\u{0a}")))))
; \x2Fbar_pl\x2Fchk\.fcgiHWAEcom\x2Findex\.php\?tpid=
(assert (str.in_re X (str.to_re "/bar_pl/chk.fcgiHWAEcom/index.php?tpid=\u{0a}")))
; ^((\+\s?\d{2}|\(?00\s?\d{2}\)?)\s?\d{2}\s?\d{3}\s?\d{4})
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "+") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.opt (str.to_re "(")) (str.to_re "00") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re ")")))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9"))))))
(check-sat)
