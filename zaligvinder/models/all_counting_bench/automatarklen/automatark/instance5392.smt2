(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\u{2f}wp-content\u{2f}themes\u{2f}[A-Za-z0-9]\.php\?[A-Za-z0-9\x2B\x2F\x3D]{300}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//wp-content/themes/") (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")) (str.to_re ".php?") ((_ re.loop 300 300) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/") (str.to_re "="))) (str.to_re "/Ui\u{0a}")))))
; A-311.*with\x3A\s+OnlineServer\u{3a}Yeah\!User-Agent\u{3a}
(assert (str.in_re X (re.++ (str.to_re "A-311") (re.* re.allchar) (str.to_re "with:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "OnlineServer:Yeah!User-Agent:\u{0a}"))))
; User-Agent\x3AHost\x3AhasHost\x3AComputerKeylogger\x2Ecom
(assert (str.in_re X (str.to_re "User-Agent:Host:hasHost:ComputerKeylogger.com\u{0a}")))
; ^([EV])?\d{3,3}(\.\d{1,2})?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "E") (str.to_re "V"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /^Host:\s*?[a-f0-9]{63,64}\./Him
(assert (not (str.in_re X (re.++ (str.to_re "/Host:") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 63 64) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "./Him\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
