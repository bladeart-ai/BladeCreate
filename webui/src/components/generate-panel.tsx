import { Button } from '@/components/ui/button'
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage
} from '@/components/ui/form'
import { Textarea } from '@/components/ui/textarea'
import { zodResolver } from '@hookform/resolvers/zod'
import { useForm } from 'react-hook-form'
import * as z from 'zod'
import { Input } from './ui/input'
import { Slider } from './ui/slider'
import { cs } from '@/store/project-store'
import { action } from 'mobx'
import { observer } from 'mobx-react-lite'

export const GeneratePanel = observer(() => {
  const generateFormSchema = z.object({
    prompt: z.string().min(2).max(50),
    negative_prompt: z.string(),
    height: z.number().int().positive(),
    width: z.number().int().positive(),
    output_num: z.number().int().positive().lte(8),
    seeds: z.string()
  })
  const form = useForm({
    resolver: zodResolver(generateFormSchema),
    defaultValues: {
      prompt: '',
      negative_prompt: '',
      width: 400,
      height: 400,
      output_num: 4,
      seeds: '-1'
    }
  })

  const onSubmit = action((values: z.infer<typeof generateFormSchema>) => {
    // Create a new layer when:
    //   1. more than one layers are selected;
    //   2. or one layer is selected but is not created from generation.
    let outputLayerUUID: string | undefined = undefined
    if (cs.selectedIDs.length === 1 && cs.ps.layers) {
      const found = Object.values(cs.ps.layers).find((item) => item.uuid === cs.selectedIDs[0])
      if (found?.generation_uuids && found?.generation_uuids.length > 0) {
        outputLayerUUID = found.uuid
      }
    }
    cs.ps.generate(outputLayerUUID, {
      prompt: values.prompt,
      negative_prompt: values.negative_prompt,
      height: values.height,
      width: values.width,
      output_number: values.output_num,
      seeds: values.seeds.split(',').map(Number)
    })
  })

  return (
    <div className="mt-2 inline-flex h-full w-full flex-col">
      <Form {...form}>
        <form className="space-y-2" onSubmit={form.handleSubmit(onSubmit)}>
          <FormField
            control={form.control}
            name="prompt"
            render={({ field }) => (
              <FormItem>
                <FormLabel className="pl-2">正向提示词</FormLabel>
                <FormControl>
                  <Textarea placeholder="正向提示词" {...field} />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="negative_prompt"
            render={({ field }) => (
              <FormItem>
                <FormLabel className="pl-2">反向提示词</FormLabel>
                <FormControl>
                  <Textarea placeholder="反向提示词" {...field} />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="height"
            render={({ field }) => (
              <FormItem>
                <FormLabel className="pl-2">{'高度: ' + field.value.toString()}</FormLabel>
                <FormControl>
                  <div className="flex flex-row">
                    <Slider
                      className="w-full"
                      defaultValue={[400]}
                      max={1600}
                      min={100}
                      onValueChange={(val) => field.onChange(val[0])}
                      step={100}
                    />
                  </div>
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="width"
            render={({ field }) => (
              <FormItem>
                <FormLabel className="pl-2">{'宽度: ' + field.value.toString()}</FormLabel>
                <FormControl>
                  <div className="flex flex-row">
                    <Slider
                      className="w-full"
                      defaultValue={[400]}
                      max={1600}
                      min={100}
                      onValueChange={(val) => field.onChange(val[0])}
                      step={100}
                    />
                  </div>
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="output_num"
            render={({ field }) => (
              <FormItem>
                <FormLabel className="pl-2">{'张数: ' + field.value.toString()}</FormLabel>
                <FormControl>
                  <div className="flex flex-row">
                    <Slider
                      className="w-full"
                      defaultValue={[4]}
                      max={8}
                      min={1}
                      onValueChange={(val) => field.onChange(val[0])}
                      step={1}
                    />
                  </div>
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="seeds"
            render={({ field }) => (
              <FormItem>
                <FormLabel className="pl-2">种子</FormLabel>
                <FormControl>
                  <Input
                    type="string"
                    {...field}
                    onChange={(event) => field.onChange(+event.target.value)}
                    placeholder="种子"
                  />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <div className="flex gap-2.5">
            <Button type="submit">生成</Button>
          </div>
        </form>
      </Form>
    </div>
  )
})
