(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; upgrade\x2Eqsrch\x2Einfo.*report.*Host\x3A.*Host\x3Akwd-i%3fUser-Agent\x3Awww\u{2e}proventactics\u{2e}com
(assert (not (str.in_re X (re.++ (str.to_re "upgrade.qsrch.info") (re.* re.allchar) (str.to_re "report") (re.* re.allchar) (str.to_re "Host:") (re.* re.allchar) (str.to_re "Host:kwd-i%3fUser-Agent:www.proventactics.com\u{0a}")))))
; /\u{2e}ogv([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.ogv") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; \x2Fta\x2FNEWS\x2F\d+Toolbarwww\x2Eonlinecasinoextra\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "/ta/NEWS/") (re.+ (re.range "0" "9")) (str.to_re "Toolbarwww.onlinecasinoextra.com\u{0a}")))))
; ^[a-zA-Z]{1}[\w\sa-zA-Z\d_]*[^\s]$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}ppsx/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ppsx/i\u{0a}"))))
(check-sat)
