(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (a|A)
(assert (str.in_re X (re.++ (re.union (str.to_re "a") (str.to_re "A")) (str.to_re "\u{0a}"))))
; /^([0-2]\d\d){75}/P
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 75 75) (re.++ (re.range "0" "2") (re.range "0" "9") (re.range "0" "9"))) (str.to_re "/P\u{0a}")))))
; Referer\x3AHost\x3AHost\x3ASubject\x3Aonline-casino-searcher\.comnetid=Excite
(assert (str.in_re X (str.to_re "Referer:Host:Host:Subject:online-casino-searcher.comnetid=Excite\u{0a}")))
; /filename=[^\n]*\u{2e}cnt/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".cnt/i\u{0a}")))))
; (Word1|Word2).*?(10|[1-9])
(assert (not (str.in_re X (re.++ (re.* re.allchar) (re.union (str.to_re "10") (re.range "1" "9")) (str.to_re "\u{0a}Word") (re.union (str.to_re "1") (str.to_re "2"))))))
(assert (> (str.len X) 10))
(check-sat)
