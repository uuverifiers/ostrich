(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \r\nSTATUS\x3AUser-Agent\x3AHost\u{3a}Referer\x3A
(assert (str.in_re X (str.to_re "\u{0d}\u{0a}STATUS:User-Agent:Host:Referer:\u{0a}")))
; /\r\n\r\nsession\u{3a}\d{1,7}$/
(assert (str.in_re X (re.++ (str.to_re "/\u{0d}\u{0a}\u{0d}\u{0a}session:") ((_ re.loop 1 7) (re.range "0" "9")) (str.to_re "/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
