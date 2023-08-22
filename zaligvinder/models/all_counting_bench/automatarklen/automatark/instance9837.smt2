(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /TimeToLive=[^&]*?(%60|\u{60})/iP
(assert (str.in_re X (re.++ (str.to_re "/TimeToLive=") (re.* (re.comp (str.to_re "&"))) (re.union (str.to_re "%60") (str.to_re "`")) (str.to_re "/iP\u{0a}"))))
; ^\d{1,2}\/\d{2,4}$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Agentppcdomain\x2Eco\x2EukWordSpy\-Locked
(assert (not (str.in_re X (str.to_re "Agentppcdomain.co.ukWordSpy-Locked\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
