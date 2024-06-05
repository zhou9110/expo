import { mergeClasses } from '@expo/styleguide';
import { Star06Icon } from '@expo/styleguide-icons';

import { TagProps } from './Tag';
import { labelStyle, tagStyle, tagToCStyle } from './styles';

import { formatName, TAG_CLASSES } from '~/ui/components/Tag/helpers';

type StatusTagProps = Omit<TagProps, 'name'> & {
  status: 'deprecated' | 'experimental' | string;
  note?: string;
};

export const StatusTag = ({ status, type, note, className }: StatusTagProps) => {
  return (
    <div
      className={mergeClasses(
        status === 'deprecated' && TAG_CLASSES['deprecated'],
        status === 'experimental' && TAG_CLASSES['experimental'],
        'select-none',
        className
      )}
      css={[tagStyle, type === 'toc' && tagToCStyle]}>
      {status === 'experimental' && <Star06Icon className="icon-xs text-palette-pink12" />}
      <span css={labelStyle}>{status ? formatName(status) + (note ? `: ${note}` : '') : note}</span>
    </div>
  );
};
