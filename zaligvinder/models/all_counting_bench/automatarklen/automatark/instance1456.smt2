(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \u{22}Thewebsearch\.getmirar\.com
(assert (not (str.in_re X (str.to_re "\u{22}Thewebsearch.getmirar.com\u{0a}"))))
; User-Agent\u{3a}\s+www\x2Einternet-optimizer\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.internet-optimizer.com\u{0a}")))))
; [D]?[-D]?[0-9]{5}
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "D")) (re.opt (re.union (str.to_re "-") (str.to_re "D"))) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \stoolbar\.anwb\.nl\s+A-311.*Host\u{3a}Host\x3Ayddznydqir\u{2f}evi
(assert (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "toolbar.anwb.nl") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "A-311") (re.* re.allchar) (str.to_re "Host:Host:yddznydqir/evi\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
