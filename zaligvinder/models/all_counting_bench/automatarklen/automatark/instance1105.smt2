(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-zA-Z0-9][-a-zA-Z0-9]*[a-zA-Z0-9]\.)+([a-zA-Z0-9]{3,5})$
(assert (not (str.in_re X (re.++ (re.+ (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (re.* (re.union (str.to_re "-") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (str.to_re "."))) ((_ re.loop 3 5) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; /<linearGradient[^>]*>\s*<\u{2f}linearGradient>/i
(assert (not (str.in_re X (re.++ (str.to_re "/<linearGradient") (re.* (re.comp (str.to_re ">"))) (str.to_re ">") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "</linearGradient>/i\u{0a}")))))
; NSIS_DOWNLOAD.*User-Agent\x3A\s+gpstool\u{2e}globaladserver\u{2e}com
(assert (str.in_re X (re.++ (str.to_re "NSIS_DOWNLOAD") (re.* re.allchar) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "gpstool.globaladserver.com\u{0a}"))))
; /filename=[^\n]*\u{2e}sum/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".sum/i\u{0a}")))))
; /\u{2e}xbm([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.xbm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
