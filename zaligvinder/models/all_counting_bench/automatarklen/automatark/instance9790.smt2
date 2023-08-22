(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; AnalSpy\-LockedacezSubject\x3A
(assert (not (str.in_re X (str.to_re "AnalSpy-LockedacezSubject:\u{0a}"))))
; ^([A-Z]{2}[\s]|[A-Z]{2})[\w]{2}$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "A" "Z"))) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
; ^[0-9]*$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
