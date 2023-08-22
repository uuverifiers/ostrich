(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\bobj\u{0a}\u{20}*?\/Pattern\u{20}*?\u{0a}endobj\b/i
(assert (not (str.in_re X (re.++ (str.to_re "/obj\u{0a}") (re.* (str.to_re " ")) (str.to_re "/Pattern") (re.* (str.to_re " ")) (str.to_re "\u{0a}endobj/i\u{0a}")))))
; \"[^"]+\"|\([^)]+\)|[^\"\s\()]+
(assert (not (str.in_re X (re.union (re.++ (str.to_re "\u{22}") (re.+ (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{22}")) (re.++ (str.to_re "(") (re.+ (re.comp (str.to_re ")"))) (str.to_re ")")) (re.++ (re.+ (re.union (str.to_re "\u{22}") (str.to_re "(") (str.to_re ")") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))))
; ^[0-9]{4}\s{0,1}[a-zA-Z]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
; ^([A-Z]{2}[\s]|[A-Z]{2})[\w]{2}$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "A" "Z"))) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
