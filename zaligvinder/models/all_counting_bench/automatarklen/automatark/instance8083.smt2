(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /META-INF.*?[a-zA-Z]{7}\.class/smi
(assert (str.in_re X (re.++ (str.to_re "/META-INF") (re.* re.allchar) ((_ re.loop 7 7) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re ".class/smi\u{0a}"))))
; ^\d{2}\s{1}(Jan|Feb|Mar|Apr|May|Jun|Jul|Apr|Sep|Oct|Nov|Dec)\s{1}\d{4}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "Jan") (str.to_re "Feb") (str.to_re "Mar") (str.to_re "Apr") (str.to_re "May") (str.to_re "Jun") (str.to_re "Jul") (str.to_re "Apr") (str.to_re "Sep") (str.to_re "Oct") (str.to_re "Nov") (str.to_re "Dec")) ((_ re.loop 1 1) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^\d{9}[\d|X]$
(assert (not (str.in_re X (re.++ ((_ re.loop 9 9) (re.range "0" "9")) (re.union (re.range "0" "9") (str.to_re "|") (str.to_re "X")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}pfb/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pfb/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
