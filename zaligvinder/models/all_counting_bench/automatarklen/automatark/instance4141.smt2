(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[-+]?\d+(\.\d)?\d*$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.range "0" "9"))) (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /^\/([a-zA-Z0-9-&+ ]+[^\/?]=){5}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 5 5) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "&") (str.to_re "+") (str.to_re " "))) (re.union (str.to_re "/") (str.to_re "?")) (str.to_re "="))) (str.to_re "/Ui\u{0a}")))))
; loomcompany\x2EcomBasedURLS\swww\.fast-finder\.com
(assert (str.in_re X (re.++ (str.to_re "loomcompany.comBasedURLS") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.fast-finder.com\u{0a}"))))
; /^User-Agent\x3A[^\r\n]*malware/miH
(assert (not (str.in_re X (re.++ (str.to_re "/User-Agent:") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "malware/miH\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
