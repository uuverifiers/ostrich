(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}eot/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".eot/i\u{0a}")))))
; ([+(]?\d{0,2}[)]?)([-/.\s]?\d+)+
(assert (str.in_re X (re.++ (re.+ (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "/") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}") (re.opt (re.union (str.to_re "+") (str.to_re "("))) ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (str.to_re ")")))))
; clvompycem\u{2f}cen\.vcn.*Host\x3A\s+toolbar_domain_redirectHost\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "clvompycem/cen.vcn") (re.* re.allchar) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "toolbar_domain_redirectHost:\u{0a}")))))
; Host\x3A\w+User-Agent\x3A\sTeomaBarHost\x3AHoursHost\x3AHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "User-Agent:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "TeomaBarHost:HoursHost:Host:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
