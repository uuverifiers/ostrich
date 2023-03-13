(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\/\/-->\s*)?<\/?SCRIPT([^>]*)>(\s*<!--\s)?
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "//-->") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (str.to_re "<") (re.opt (str.to_re "/")) (str.to_re "SCRIPT") (re.* (re.comp (str.to_re ">"))) (str.to_re ">") (re.opt (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "<!--") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "\u{0a}"))))
; ".*?"|".*$|'.*?'|'.*$
(assert (str.in_re X (re.union (re.++ (str.to_re "\u{22}") (re.* re.allchar) (str.to_re "\u{22}")) (re.++ (str.to_re "\u{22}") (re.* re.allchar)) (re.++ (str.to_re "'") (re.* re.allchar) (str.to_re "'")) (re.++ (str.to_re "'") (re.* re.allchar) (str.to_re "\u{0a}")))))
; AdTools\d+rprpgbnrppb\u{2f}ciExplorer\x2Fsto=notificationfindwww\x2Emakemesearch\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "AdTools") (re.+ (re.range "0" "9")) (str.to_re "rprpgbnrppb/ciExplorer/sto=notification\u{13}findwww.makemesearch.com\u{0a}")))))
; (\s+|)((\(\d{3}\) +)|(\d{3}-)|(\d{3} +))?\d{3}(-| +)\d{4}( +x\d{1,4})?(\s+|)
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") (re.+ (str.to_re " "))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.+ (str.to_re " "))))) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (re.+ (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.++ (re.+ (str.to_re " ")) (str.to_re "x") ((_ re.loop 1 4) (re.range "0" "9")))) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; IDENTIFY.*\x2Fezsb\d+X-Mailer\x3A
(assert (str.in_re X (re.++ (str.to_re "IDENTIFY") (re.* re.allchar) (str.to_re "/ezsb") (re.+ (re.range "0" "9")) (str.to_re "X-Mailer:\u{13}\u{0a}"))))
(check-sat)
