(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; AD\s+c\.goclick\.com\w+asdbiz\x2Ebizfrom\u{7c}roogoo\u{7c}Current
(assert (str.in_re X (re.++ (str.to_re "AD") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "c.goclick.com") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "asdbiz.bizfrom|roogoo|Current\u{0a}"))))
; /^\/[\w-]{48}\.[a-z]{2,8}[0-9]?$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 48 48) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 2 8) (re.range "a" "z")) (re.opt (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
; ^\\([^\\]+\\)*[^\/:*?"<>|]?$
(assert (str.in_re X (re.++ (str.to_re "\u{5c}") (re.* (re.++ (re.+ (re.comp (str.to_re "\u{5c}"))) (str.to_re "\u{5c}"))) (re.opt (re.union (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) (str.to_re "\u{0a}"))))
; /\u{2e}pcx([\u{3f}\u{2f}]|$)/Uim
(assert (not (str.in_re X (re.++ (str.to_re "/.pcx") (re.union (str.to_re "?") (str.to_re "/")) (str.to_re "/Uim\u{0a}")))))
; /setup=[a-z]$/Ui
(assert (str.in_re X (re.++ (str.to_re "/setup=") (re.range "a" "z") (str.to_re "/Ui\u{0a}"))))
(check-sat)
