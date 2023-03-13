(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\u{2f}[0-9A-F]{42}$/Um
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 42 42) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/Um\u{0a}"))))
; EFError\swww\u{2e}malware-stopper\u{2e}com
(assert (not (str.in_re X (re.++ (str.to_re "EFError") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.malware-stopper.com\u{0a}")))))
; \x2Frssupdate\.cgiToolbarsearch\.dropspam\.com
(assert (str.in_re X (str.to_re "/rssupdate.cgiToolbarsearch.dropspam.com\u{0a}")))
(check-sat)
