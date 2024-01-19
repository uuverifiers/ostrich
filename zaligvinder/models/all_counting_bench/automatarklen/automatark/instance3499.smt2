(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3AWeb-Mail
(assert (not (str.in_re X (str.to_re "User-Agent:Web-Mail\u{0a}"))))
; [0-9]{4}\s*[a-zA-Z]{2}
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
