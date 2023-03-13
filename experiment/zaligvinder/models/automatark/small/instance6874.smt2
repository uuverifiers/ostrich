(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ProAgentHost\u{3a}Host\x3AiOpuss_sq=aolsnssigninwininet
(assert (str.in_re X (str.to_re "ProAgentHost:Host:iOpuss_sq=aolsnssigninwininet\u{0a}")))
; ^((AL)|(AK)|(AS)|(AZ)|(AR)|(CA)|(CO)|(CT)|(DE)|(DC)|(FM)|(FL)|(GA)|(GU)|(HI)|(ID)|(IL)|(IN)|(IA)|(KS)|(KY)|(LA)|(ME)|(MH)|(MD)|(MA)|(MI)|(MN)|(MS)|(MO)|(MT)|(NE)|(NV)|(NH)|(NJ)|(NM)|(NY)|(NC)|(ND)|(MP)|(OH)|(OK)|(OR)|(PW)|(PA)|(PR)|(RI)|(SC)|(SD)|(TN)|(TX)|(UT)|(VT)|(VI)|(VA)|(WA)|(WV)|(WI)|(WY))$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "AL") (str.to_re "AK") (str.to_re "AS") (str.to_re "AZ") (str.to_re "AR") (str.to_re "CA") (str.to_re "CO") (str.to_re "CT") (str.to_re "DE") (str.to_re "DC") (str.to_re "FM") (str.to_re "FL") (str.to_re "GA") (str.to_re "GU") (str.to_re "HI") (str.to_re "ID") (str.to_re "IL") (str.to_re "IN") (str.to_re "IA") (str.to_re "KS") (str.to_re "KY") (str.to_re "LA") (str.to_re "ME") (str.to_re "MH") (str.to_re "MD") (str.to_re "MA") (str.to_re "MI") (str.to_re "MN") (str.to_re "MS") (str.to_re "MO") (str.to_re "MT") (str.to_re "NE") (str.to_re "NV") (str.to_re "NH") (str.to_re "NJ") (str.to_re "NM") (str.to_re "NY") (str.to_re "NC") (str.to_re "ND") (str.to_re "MP") (str.to_re "OH") (str.to_re "OK") (str.to_re "OR") (str.to_re "PW") (str.to_re "PA") (str.to_re "PR") (str.to_re "RI") (str.to_re "SC") (str.to_re "SD") (str.to_re "TN") (str.to_re "TX") (str.to_re "UT") (str.to_re "VT") (str.to_re "VI") (str.to_re "VA") (str.to_re "WA") (str.to_re "WV") (str.to_re "WI") (str.to_re "WY")) (str.to_re "\u{0a}")))))
; ^(3(([0-5][0-9]{0,2})|60))|([1-2][0-9]{2})|(^[1-9]$)|(^[1-9]{2}$)$
(assert (not (str.in_re X (re.union (re.++ (str.to_re "3") (re.union (re.++ (re.range "0" "5") ((_ re.loop 0 2) (re.range "0" "9"))) (str.to_re "60"))) (re.++ (re.range "1" "2") ((_ re.loop 2 2) (re.range "0" "9"))) (re.range "1" "9") (re.++ ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re "\u{0a}"))))))
; ^[A-Z]{3}-[0-9]{4}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ChildWebGuardian\d+Subject\x3A
(assert (not (str.in_re X (re.++ (str.to_re "ChildWebGuardian") (re.+ (re.range "0" "9")) (str.to_re "Subject:\u{0a}")))))
(check-sat)
