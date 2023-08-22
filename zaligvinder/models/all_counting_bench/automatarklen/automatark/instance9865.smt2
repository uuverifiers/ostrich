(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /GET \/[a-z]{8,12}\?[a-z] HTTP\/1.1/i
(assert (not (str.in_re X (re.++ (str.to_re "/GET /") ((_ re.loop 8 12) (re.range "a" "z")) (str.to_re "?") (re.range "a" "z") (str.to_re " HTTP/1") re.allchar (str.to_re "1/i\u{0a}")))))
; /css\s*?\u{28}\s*?[\u{22}\u{27}]margin[^\u{29}]*?[\u{22}\u{27}]\s*?\u{2c}\s*?[\u{22}\u{27}]\d{12,}\s*?px/smi
(assert (str.in_re X (re.++ (str.to_re "/css") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "margin") (re.* (re.comp (str.to_re ")"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ",") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "px/smi\u{0a}") ((_ re.loop 12 12) (re.range "0" "9")) (re.* (re.range "0" "9")))))
; /filename=[^\n]*\u{2e}pdf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pdf/i\u{0a}"))))
; /filename=[^\n]*\u{2e}gz/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".gz/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
