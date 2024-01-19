(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}rmp/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rmp/i\u{0a}")))))
; /version\x3D[\u{22}\u{27}][^\u{22}\u{27}]{1024}/
(assert (str.in_re X (re.++ (str.to_re "/version=") (re.union (str.to_re "\u{22}") (str.to_re "'")) ((_ re.loop 1024 1024) (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
