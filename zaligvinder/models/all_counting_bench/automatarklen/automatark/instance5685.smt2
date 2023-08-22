(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\s+\.ico\x2FsLogearch195\.225\.Referer\x3A
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".ico/sLogearch195.225.Referer:\u{0a}"))))
; /NICK A\[New\|(98|Me|NT4.0|2000|XP|Serv2003|Vis|7|Unk)\|x(86|64)\|[A-Z\-]{1,2}\|[0-9]{1,4}\]/
(assert (str.in_re X (re.++ (str.to_re "/NICK A[New|") (re.union (str.to_re "98") (str.to_re "Me") (re.++ (str.to_re "NT4") re.allchar (str.to_re "0")) (str.to_re "2000") (str.to_re "XP") (str.to_re "Serv2003") (str.to_re "Vis") (str.to_re "7") (str.to_re "Unk")) (str.to_re "|x") (re.union (str.to_re "86") (str.to_re "64")) (str.to_re "|") ((_ re.loop 1 2) (re.union (re.range "A" "Z") (str.to_re "-"))) (str.to_re "|") ((_ re.loop 1 4) (re.range "0" "9")) (str.to_re "]/\u{0a}"))))
; HXDownload\s+Host\x3AArcadeHourspjpoptwql\u{2f}rlnjFrom\x3A
(assert (str.in_re X (re.++ (str.to_re "HXDownload") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:ArcadeHourspjpoptwql/rlnjFrom:\u{0a}"))))
; \x0D\x0ACurrent\x2EearthlinkSpyBuddy
(assert (str.in_re X (str.to_re "\u{0d}\u{0a}Current.earthlinkSpyBuddy\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
