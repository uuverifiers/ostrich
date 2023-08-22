(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; EFError\swww\u{2e}malware-stopper\u{2e}com
(assert (not (str.in_re X (re.++ (str.to_re "EFError") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.malware-stopper.com\u{0a}")))))
; ^[-]?\d*(\.\d*)$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}.") (re.* (re.range "0" "9"))))))
; ^\d{5}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\/ddd\/[a-z]{2}.gif/iU
(assert (str.in_re X (re.++ (str.to_re "//ddd/") ((_ re.loop 2 2) (re.range "a" "z")) re.allchar (str.to_re "gif/iU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
