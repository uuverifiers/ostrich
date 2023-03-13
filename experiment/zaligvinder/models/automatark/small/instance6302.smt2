(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z]{1}( |-)?[1-9]{1}[0-9]{3}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; frame_ver2www\.raxsearch\.comaboutGoogleyxegtd\u{2f}efcwgHost\x3ATPSystemwww\x2Ee-finder\x2Ecc
(assert (str.in_re X (str.to_re "frame_ver2www.raxsearch.comaboutGoogleyxegtd/efcwgHost:TPSystemwww.e-finder.cc\u{0a}")))
(check-sat)
