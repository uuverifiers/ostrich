(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \d{2}.?\d{3}.?\d{3}/?\d{4}-?\d{2}
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt re.allchar) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt re.allchar) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "/")) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Online\u{25}21\u{25}21\u{25}21\sUser-Agent\x3A\d+HXDownloadasdbiz\x2Ebiz
(assert (str.in_re X (re.++ (str.to_re "Online%21%21%21") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "HXDownloadasdbiz.biz\u{0a}"))))
(check-sat)
