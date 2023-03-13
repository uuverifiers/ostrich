(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Subject\u{3a}\s+Yeah\!Online\u{25}21\u{25}21\u{25}21
(assert (str.in_re X (re.++ (str.to_re "Subject:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Yeah!Online%21%21%21\u{0a}"))))
; /hwid=[^\u{0a}\u{26}]+?\u{26}pc=[^\u{0a}\u{26}]+?\u{26}localip=[^\u{0a}\u{26}]+?\u{26}winver=/U
(assert (str.in_re X (re.++ (str.to_re "/hwid=") (re.+ (re.union (str.to_re "\u{0a}") (str.to_re "&"))) (str.to_re "&pc=") (re.+ (re.union (str.to_re "\u{0a}") (str.to_re "&"))) (str.to_re "&localip=") (re.+ (re.union (str.to_re "\u{0a}") (str.to_re "&"))) (str.to_re "&winver=/U\u{0a}"))))
; /^\d{2}[\-\/]\d{2}[\-\/]\d{4}$/
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re "/")) ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re "/")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/\u{0a}"))))
(check-sat)
