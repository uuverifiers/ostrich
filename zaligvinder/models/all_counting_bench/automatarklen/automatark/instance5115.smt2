(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[\u{22}\u{27}]?\d\.exe[\u{22}\u{27}]?/Hi
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.opt (re.union (str.to_re "\u{22}") (str.to_re "'"))) (re.range "0" "9") (str.to_re ".exe") (re.opt (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "/Hi\u{0a}"))))
; DaysinfoBackAtTaCkwww\x2Ealfacleaner\x2Ecom
(assert (str.in_re X (str.to_re "DaysinfoBackAtTaCkwww.alfacleaner.com\u{0a}")))
; ((\(\d{3}\) ?)|(\d{3}[- \.]))?\d{3}[- \.]\d{4}(\s(x\d+)?){0,1}$
(assert (not (str.in_re X (re.++ (re.opt (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") (re.opt (str.to_re " "))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "."))))) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ") (str.to_re ".")) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.opt (re.++ (str.to_re "x") (re.+ (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
