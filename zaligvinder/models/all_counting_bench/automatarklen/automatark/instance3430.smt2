(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[^\s]+@[^\.][^\s]{1,}\.[A-Za-z]{2,10}$
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "@") (re.comp (str.to_re ".")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".") ((_ re.loop 2 10) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}")))))
; /^(\u{00}\u{00}\u{00}\u{00}|.{4}(\u{00}\u{00}\u{00}\u{00}|.{12}))/s
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "\u{00}\u{00}\u{00}\u{00}") (re.++ ((_ re.loop 4 4) re.allchar) (re.union (str.to_re "\u{00}\u{00}\u{00}\u{00}") ((_ re.loop 12 12) re.allchar)))) (str.to_re "/s\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
