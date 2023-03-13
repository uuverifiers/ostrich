(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ClientsConnected-\d+online-casino-searcher\.com\s+Warezxmlns\x3A
(assert (not (str.in_re X (re.++ (str.to_re "ClientsConnected-") (re.+ (re.range "0" "9")) (str.to_re "online-casino-searcher.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Warezxmlns:\u{0a}")))))
; Host\u{3a}\w+Pre.*Keyloggeradfsgecoiwnfhirmvtg\u{2f}ggqh\.kqh
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Pre") (re.* re.allchar) (str.to_re "Keyloggeradfsgecoiwnf\u{1b}hirmvtg/ggqh.kqh\u{1b}\u{0a}")))))
; ^(BE)[0-1]{1}[0-9]{9}$|^((BE)|(BE ))[0-1]{1}(\d{3})([.]{1})(\d{3})([.]{1})(\d{3})
(assert (str.in_re X (re.union (re.++ (str.to_re "BE") ((_ re.loop 1 1) (re.range "0" "1")) ((_ re.loop 9 9) (re.range "0" "9"))) (re.++ (re.union (str.to_re "BE") (str.to_re "BE ")) ((_ re.loop 1 1) (re.range "0" "1")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; c\.goclick\.com\s+URLBlaze\s+Host\x3A
(assert (not (str.in_re X (re.++ (str.to_re "c.goclick.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "URLBlaze") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}")))))
; [0-9A-Fa-f]{2}(\.?)[0-9A-Fa-f]{2}(\.?)[0-9A-Fa-f]{2}(\.?)[0-9A-Fa-f]{2}
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "F") (re.range "a" "f"))) (re.opt (str.to_re ".")) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "F") (re.range "a" "f"))) (re.opt (str.to_re ".")) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "F") (re.range "a" "f"))) (re.opt (str.to_re ".")) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "F") (re.range "a" "f"))) (str.to_re "\u{0a}")))))
(check-sat)
