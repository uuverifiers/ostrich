(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \r\nSTATUS\x3A\dHost\u{3a}Referer\x3AServerSubject\u{3a}
(assert (str.in_re X (re.++ (str.to_re "\u{0d}\u{0a}STATUS:") (re.range "0" "9") (str.to_re "Host:Referer:ServerSubject:\u{0a}"))))
; node=Host\x3A\x3Fsearch\x3DversionContactNETObserve
(assert (not (str.in_re X (str.to_re "node=Host:?search=versionContactNETObserve\u{0a}"))))
; www\x2Eweepee\x2Ecomhttp\x0D\x0ACurrentOwner\x3A
(assert (str.in_re X (str.to_re "www.weepee.com\u{1b}http\u{0d}\u{0a}CurrentOwner:\u{0a}")))
; ^([0-9a-fA-F][0-9a-fA-F]:){5}([0-9a-fA-F][0-9a-fA-F])$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.++ (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F")) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F")) (str.to_re ":"))) (str.to_re "\u{0a}") (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F")) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))))))
; ^\d{5}$|^\d{5}-\d{4}$
(assert (not (str.in_re X (re.union ((_ re.loop 5 5) (re.range "0" "9")) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(check-sat)
