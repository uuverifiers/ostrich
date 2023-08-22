(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; toetbuviaebe\u{2f}eqv\.bvvuplink\x2Eco\x2Ekrwv=Host\x3A
(assert (not (str.in_re X (str.to_re "toetbuviaebe/eqv.bvvuplink.co.krwv=Host:\u{0a}"))))
; ^(\+(1\-)?\d{1,3})?(\s|\-)?(\s|\-)?((\(\d{2}\)|\d{2})(\s|\-)?\d{4}|(\(\d{3}\)|\d{3})(\s|\-)?\d{3})(\s|\-)?\d{4}(\s)?(x|ext|ext.)?(\d{1,6})?,?(\d{1,6})?,?(\d{1,6})?$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re "+") (re.opt (str.to_re "1-")) ((_ re.loop 1 3) (re.range "0" "9")))) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.++ (re.union (re.++ (str.to_re "(") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "x") (str.to_re "ext") (re.++ (str.to_re "ext") re.allchar))) (re.opt ((_ re.loop 1 6) (re.range "0" "9"))) (re.opt (str.to_re ",")) (re.opt ((_ re.loop 1 6) (re.range "0" "9"))) (re.opt (str.to_re ",")) (re.opt ((_ re.loop 1 6) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; \x2Fdss\x2Fcc\.2_0_0\.GoogleHXDownloadasdbiz\x2Ebiz
(assert (not (str.in_re X (str.to_re "/dss/cc.2_0_0.GoogleHXDownloadasdbiz.biz\u{0a}"))))
; ^[0-3][0-9][0-1]\d{3}-\d{4}?
(assert (str.in_re X (re.++ (re.range "0" "3") (re.range "0" "9") (re.range "0" "1") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^\d{2}([0][1-9]|[1][0-2])([0][1-9]|[1-2][0-9]|[3][0-1])-\d{4}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
