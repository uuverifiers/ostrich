(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; stats\u{2e}drivecleaner\u{2e}comExciteasdbiz\x2Ebiz
(assert (str.in_re X (str.to_re "stats.drivecleaner.com\u{13}Exciteasdbiz.biz\u{0a}")))
; www\x2Epurityscan\x2Ecom\s+from\.myway\.comToolbarUI2
(assert (str.in_re X (re.++ (str.to_re "www.purityscan.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "from.myway.com\u{1b}ToolbarUI2\u{0a}"))))
; ^(([1-9]{1})|([0-1][0-9])|([1-2][0-3])):([0-5][0-9])$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (re.range "1" "2") (re.range "0" "3"))) (str.to_re ":\u{0a}") (re.range "0" "5") (re.range "0" "9")))))
(assert (> (str.len X) 10))
(check-sat)
