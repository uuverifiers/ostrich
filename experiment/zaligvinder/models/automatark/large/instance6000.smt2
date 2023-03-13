(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; wowokay\d+FTP\s+Host\x3AFiltered\u{22}reaction\x2Etxt\u{22}
(assert (str.in_re X (re.++ (str.to_re "wowokay") (re.+ (re.range "0" "9")) (str.to_re "FTP") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Filtered\u{22}reaction.txt\u{22}\u{0a}"))))
; (Mo(n(day)?)?|Tu(e(sday)?)?|We(d(nesday)?)?|Th(u(rsday)?)?|Fr(i(day)?)?|Sa(t(urday)?)?|Su(n(day)?)?)
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "Mo") (re.opt (re.++ (str.to_re "n") (re.opt (str.to_re "day"))))) (re.++ (str.to_re "Tu") (re.opt (re.++ (str.to_re "e") (re.opt (str.to_re "sday"))))) (re.++ (str.to_re "We") (re.opt (re.++ (str.to_re "d") (re.opt (str.to_re "nesday"))))) (re.++ (str.to_re "Th") (re.opt (re.++ (str.to_re "u") (re.opt (str.to_re "rsday"))))) (re.++ (str.to_re "Fr") (re.opt (re.++ (str.to_re "i") (re.opt (str.to_re "day"))))) (re.++ (str.to_re "Sa") (re.opt (re.++ (str.to_re "t") (re.opt (str.to_re "urday"))))) (re.++ (str.to_re "Su") (re.opt (re.++ (str.to_re "n") (re.opt (str.to_re "day")))))) (str.to_re "\u{0a}"))))
; /^\u{2f}wp-content\u{2f}themes\u{2f}[A-Za-z0-9]\.php\?[A-Za-z0-9\x2B\x2F\x3D]{300}/Ui
(assert (str.in_re X (re.++ (str.to_re "//wp-content/themes/") (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")) (str.to_re ".php?") ((_ re.loop 300 300) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/") (str.to_re "="))) (str.to_re "/Ui\u{0a}"))))
; Pass-Onseqepagqfphv\u{2f}sfdcargo=dnsgpstool\u{2e}globaladserver\u{2e}com
(assert (not (str.in_re X (str.to_re "Pass-Onseqepagqfphv/sfdcargo=dnsgpstool.globaladserver.com\u{0a}"))))
(check-sat)
